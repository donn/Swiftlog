//SWIFTLOG: main.v
import Swiftlog
import VPIAssistant

@_cdecl("swiftlog_startup")
func startup()
{
     //Swiftlog Style
    let helloWorld = Procedure(name: "$hello_world", executionClosure: {
        _ in
        print("...and Hello from Swift!")
        return true
    })
    helloWorld.register()

    //C Style
    var showResult = s_vpi_systf_data();
    showResult.type = vpiSysTask
    showResult.tfname = "$show_result".cPointer.cLiteral
    showResult.compiletf =
    {
        (user_data: UnsafeMutablePointer<Int8>?) -> Int32 in

        guard let handle = vpi_handle(vpiSysTfCall, nil)
        else
        {
            print("Fatal Error: $show_result failed to obtain handle. The simulation will abort.")
            Control.finish()
            return 0
        }
        
        guard let iterator = vpi_iterate(vpiArgument, handle)
        else
        {
            print("$show_result requires one argument. The simulation will abort.")
            Control.finish()
            return 0
        }

        var count = 0
        while let argument = vpi_scan(iterator)
        {
            count += 1
            let type = vpi_get(vpiType, argument)

            if type != vpiNet && type != vpiReg
            {
                print("Invalid argument.")
                Control.finish()
                return 0
            }
        }

        if count > 1
        {
            print("$show_result requires one argument. The simulation will abort.")
            Control.finish()
        }

        return 0
    }
    showResult.calltf  =
    {
        (user_data: UnsafeMutablePointer<Int8>?) -> Int32 in

        guard let handle = vpi_handle(vpiSysTfCall, nil)
        else
        {
            print("Fatal Error: $show_result failed to obtain handle. The simulation will abort.")
            Control.finish()
            return 0
        }
        
        let iterator = vpi_iterate(vpiArgument, handle)!

        let net = vpi_scan(iterator)

        var value = s_vpi_value()
        value.format = vpiIntVal
        vpi_get_value(net, &value)

        print("Result:", value.value.integer)

        return 0
    }
    showResult.sizetf = nil
    showResult.user_data = nil
    vpi_register_systf(&showResult);
}