##  Invoking an OWASP AppSensor Java method from .NET C# REPL (using Jni4Net) 

On the topic of [AppSensor](https://www.owasp.org/index.php/OWASP_AppSensor_Project), you might find the code snippet below interesting. 

Inside an [O2 Platform](http://blog.diniscruz.com/p/owasp-o2-platform.html) [C# REPL editor](http://blog.diniscruz.com/p/c-repl-script-environment.html) (which is running in .Net's CLR), I was able to:

  * load the AppSensor jar in a new class loader, 
  * access/view its classes in a GUI 
  * create an instance of **_org.owasp.appsensor.trendmonitoring.TrendEvent_** 
  * execute the **_getTime _**method). 
  
Note that the AppSensor code is running on the Java's JVM (loaded in the same process as the .Net's CLR)

The code is still in very rough status, but it works :)  

Here (screenshot below) is what it looks like:

  * note the Date value in the output window (bottom right) which is the result (shown as a .NET String) of the Java getTime method
  * on top you have a view into the AppSensor's classes, methods, parameters, return type
  * on the bottom left you can see the written C# REPL script

  
[![CropperCapture[34]](images/CropperCapture_25255B34_25255D_thumb.jpg)](http://lh3.ggpht.com/-HnSr88dj64U/US9J2xS01_I/AAAAAAAAJ20/FvBxODcdj8c/s1600-h/CropperCapture%25255B34%25255D%25255B2%25255D.jpg)

Here is the code:  

    
    //var topPanel = "{name}".popupWindow(700,400);  
    var topPanel = panel.clear().add_Panel();  
    //"".open_ConsoleOut();

    var jarToLoad = @"E:/_Code_Tests/_AppSensor/AppSensor-0.1.3.jar";
    
    
    var bridgeSetup = new BridgeSetup(){Verbose=true};
    
    var jniAction = new API_Jni4Net_Active();
    
    //bridgeSetup.AddClassPath(jarToLoad);  
    //return "here";  
    try  
    {  
        Bridge.CreateJVM(bridgeSetup);  
    }  
    catch(System.Exception ex)  
    {  
        ex.log();  
        return "error";  
    }

    var jniEnv = JNIEnv.ThreadEnv;

    //calculate list of classes in Jar file  
    var jarFile = Class.forName("java.util.jar.JarFile")  
                       .getConstructor(new java.lang.Class[] { java.lang.String._class })  
                       .newInstance (new java.lang.Object[] { jniEnv.NewString(jarToLoad) });

    var entries = jarFile.getClass().getMethod("entries",null)  
                                    .invoke(jarFile, null);  
    var hasMoreElements = entries.getClass().getMethod("hasMoreElements",null);  
    var nextElement = entries.getClass().getMethod("nextElement",null);  
    var classesInJar = new List<string>();  
    while((bool)(java.lang.Boolean)hasMoreElements.invoke(entries, null))  
    {  
        var path = nextElement.invoke(entries, null).str();  
        if (path.ends(".class"))  
        classesInJar.add(path.remove(".class").replace("/","."));  
    }

    //Get class loader for Jar

  
    var jarToLoad_asUrl = new java.io.File(jarToLoad).toURL();  
    var servletApi_asUrl = new java.io.File(@"E:\_Code_Tests\_AppSensor\servlet-api.jar").toURL();

    //var url = new java.net.URL(jarToLoad);

    var urlArray = jniEnv.NewObjectArray(2, java.net.URL._class, null);  
    jniEnv.SetObjectArrayElement(urlArray, 0, jarToLoad_asUrl);  
    jniEnv.SetObjectArrayElement(urlArray, 1, servletApi_asUrl);

    var urlClassLoaderClass = java.lang.Class.forName("java.net.URLClassLoader");

    var ctor = urlClassLoaderClass.getConstructors()[2];   
    var systemClassLoader = ClassLoader.getSystemClassLoader();  
    var urlClassLoader = (ClassLoader)ctor.newInstance(new java.lang.Object[] { urlArray, systemClassLoader });

  
    //var appSensorClass = urlClassLoader.loadClass("org.owasp.appsensor.APPSENSOR");  
    //var appSensorClass = urlClassLoader.loadClass("org.owasp.appsensor.trendmonitoring.reference.InMemoryTrendDataStore$1");

    foreach(var classInJar in classesInJar)  
    {   
        try  
        {  
            urlClassLoader.loadClass(classInJar);  
            "Loaded class: {0}".info(classInJar);  
        }  
        catch(System.Exception ex)  
        {  
            "Failed to load {0} due to {1}".error(classInJar, ex.Message);  
        }  
    }

    var treeView = topPanel.add_TreeView().java_SetTreeView_To_Show_Jni4Net_Reflection_Data();  
    var loadedClasses = jniAction.java_From_ClassLoader_get_Loaded_Classes(urlClassLoader);  
    treeView.add_Nodes(loadedClasses, (@class)=>@class.getName(), true);

    //invoke a method from AppSensor  
    var trendEvent = urlClassLoader.loadClass("org.owasp.appsensor.trendmonitoring.TrendEvent").getConstructors().first()  
                                   .newInstance(new java.lang.Object[] { new Date(),  
    jniEnv.NewString("1"),  
    jniEnv.NewString("aaa"),  
    jniEnv.NewString("ccc") }) ;  
    return trendEvent.getClass()  
                     .getMethod("getTime",null).invoke(trendEvent,null)  
                     .str();

  
    //return loadedClasses;   
    /*  
    //Get JavaProperties from the loaded JVM  
    Properties javaSystemProperties = java.lang.System.getProperties();  
    foreach (java.lang.String key in Adapt.Enumeration(javaSystemProperties.keys()))  
        "key: {0}".info(key);   
    return javaSystemProperties;  
    */  
    return "ok";  
    //using java.io;  
    //using java.lang;  
    //using java.util;  
    //using net.sf.jni4net;  
    //using net.sf.jni4net.jni  
    //using net.sf.jni4net.adaptors;  
    //O2Ref:Jni4Net/lib/jni4net.n-0.8.6.0.dll

    //O2File:API_Jni4Net_Active.cs  
  
note: this code sample was running on the x64 version of the O2 Platform (because the default JavaHome in my dev VM points to a x64 Java version)
