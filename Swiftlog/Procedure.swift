import VPIAssistant

public enum Value: Int
{
    case BinaryString = 1
    case OctalString = 2
    case DecimalString = 3
    case HexadecimalString = 4
    case Scalar = 5
    case Integer = 6
    case Real = 7
    case String = 8
    case Vector = 9
    case Strength = 10
    case Time = 11
    case ObjectType = 12
    case Suppressed = 13
}

public enum ObjectType: Int
{
    case Constant = 7
    case Function = 20
    case Integer = 25
    case Iterator = 27
    case Memory = 29
    case MemoryWord = 30
    case ModulePath = 31
    case Module = 32
    case NamedBegin = 33
    case NamedEvent = 34
    case NamedFork = 35
    case Net = 36
    case Parameter = 41
    case PartSelect = 42
    case PathTerm = 43
    case Real = 47
    case Register = 48
    case FunctionCall = 56
    case TaskCall = 57
    case Task = 59
    case Time = 63
    case NetArray = 114
    case Index = 78
    case LeftRange = 79
    case Parent = 81
    case RightRange = 83
    case Scope = 84
    case AnyCall = 85
    case Argument = 89
    case InternalScope = 92
    case ModPathIn = 95
    case ModPathOut = 96
    case Variables = 100
    case Expression = 102

    case Callback = 1000
}

public struct Object
{
    private var handle: vpiHandle
    
    public var type: ObjectType? {
        return ObjectType(rawValue: Int(vpi_get(vpiType, handle)))
    }

    init(handle: vpiHandle)
    {
        self.handle = handle
    }
}

public enum ProcedureType: Int
{
    case Task = 1
    case Func = 2
}

public class Procedure
{
    private var store: s_vpi_systf_data
    private var compiletf: (UnsafeMutablePointer<Int8>?) -> (Int32)
    private var name: String
    private var cNameSize: Int
    private var cNamePointer: UnsafeMutablePointer<UInt8>
    private var type: ProcedureType
    private var arguments: [Object]
    private var registered: Bool
    private var validate: ((_: inout [Any]) -> (Bool))?
    private var execute: (_: inout [Any]) -> (Bool)
    
    init(name: String, type: ProcedureType = .Task, arguments: [Object], validationClosure: ((_: inout [Any]) -> (Bool))? = nil, executionClosure: @escaping (_: inout [Any]) -> (Bool), register: Bool = true)
    {
        self.name = name
        self.type = type
        self.arguments = arguments
        self.validate = validationClosure
        self.execute = executionClosure
        self.store = s_vpi_systf_data()

        let pointers = self.name.cPointer
        self.cNameSize = pointers.elementCount
        self.cNamePointer = pointers.mutable
        self.store.tfname = pointers.literal

        self.store.type = PLI_INT32(self.type.rawValue)
        self.store.compiletf = {
            (user_data: UnsafeMutablePointer<Int8>?) -> Int32 in
            return 0
        } //So it doesn't complain about not everything being initialize before self is used in a method like a goddamn baby
        self.store.calltf = {
            (user_data: UnsafeMutablePointer<Int8>?) -> Int32 in
            return 0
        } //See above
        self.registered = true
        // self.store.compiletf =  {
        //     (user_data: UnsafeMutablePointer<Int8>?) -> Int32 in
        //     return self.compile(user_data: user_data)
        // } //Error here
        vpi_register_systf(&self.store);

    }

    func compile(user_data: UnsafeMutablePointer<Int8>?) -> Int32
    {
        guard let handle = vpi_handle(vpiSysTfCall, nil)
        else
        {
            print("Fatal Error: $\(self.name) failed to obtain handle. The simulation will abort.")
            Control.finish()
            return 0
        }

        if arguments.count >= 0
        {
        
            guard let iterator = vpi_iterate(vpiArgument, handle)
            else
            {
                print("$\(self.name) requires \(arguments.count) argument(s). The simulation will abort.")
                Control.finish()
                return 0
            }

            var count = 0
            while let argument = vpi_scan(iterator)
            {
                count += 1
                let type = vpi_get(vpiType, argument)

                if Int(type) != self.arguments[count].type?.rawValue
                {
                    print("$\(self.name), argument \(count): Invalid argument type.")
                    Control.finish()
                    return 0
                }
            }

            if count != arguments.count
            {
                print("$\(self.name) requires \(arguments.count) argument(s) (\(count) provided). The simulation will abort.")
                Control.finish()
            }
        }

        return 0
    }

    deinit
    {
        self.cNamePointer.deallocate(capacity: self.cNameSize)
    }

}