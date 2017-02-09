import VPIAssistant

/*
      startup

      Do ALL your setup here. No, really. ~All of it~. This is the equivalent of a main function.
*/
func startup()
{
      //Register Function "$hello_world"
      var helloWorld = s_vpi_systf_data();
      helloWorld.type = vpiSysTask
      helloWorld.tfname = UnsafePointer<Int8>!(UTF8String("$hello_world"))
      helloWorld.calltf  = {
            (user_data: UnsafeMutablePointer<PLI_BYTE8>?) -> PLI_INT32 in
            print("..and Hello from Swift!")
            return 0
      }
      helloWorld.compiletf = {
            (user_data: UnsafeMutablePointer<PLI_BYTE8>?) -> PLI_INT32 in
            return 0
      }
      helloWorld.sizetf = nil
      helloWorld.user_data = nil
      vpi_register_systf(&helloWorld);
}