##  Loading OWASP ESAPI jar and its dependencies from C# (using jni4net) 

Here is a pretty cool PoC where I was able to load an jar file and its dependencies into an '[Jni4Net](http://jni4net.sourceforge.net/) created' JVM

  
**Using the system class loader**  

here is the esapi class we want to load (the code below returns null)  

    
    new API_Jni4Net().setUpBride();
    return "org.owasp.esapi.util.ObjFactory".java_Class();  

Using the technique shown in [Adding files to java classpath at runtime - Stack Overflow](http://stackoverflow.com/questions/1010919/adding-files-to-java-classpath-at-runtime) , we can add the esapi jar into the sysLoader class path  

    
    new API_Jni4Net().setUpBride();
    
    var esapiJar = @"E:\_Code_Tests\ESAPI\esapi-2.0.1.jar";  
    var classLoader = ClassLoader.getSystemClassLoader();  
    var addUrl = classLoader.getClass().getSuperclass().getDeclaredMethod("addURL", new Class[]{URL._class});  
    addUrl.setAccessible(true);  
    addUrl.invoke(classLoader, new java.lang.Object[]{ esapiJar.java_File().toURL() });
    
    return "org.owasp.esapi.util.ObjFactory".java_Class();
    
    //using net.sf.jni4net.jni;  
    //using java.lang;  
    //using java.net;  
    //O2File:API_Jni4Net.cs  
    //O2Ref:jni4net.n-0.8.6.0.dll  
  
which will now work:

[![image](images/image_thumb1.png)](http://lh4.ggpht.com/-0h2xiNX0wjQ/UTCHoVb2YJI/AAAAAAAAJ_g/jP8WGBWg-nQ/s1600-h/image%25255B2%25255D.png)

If we now try to load all classes in the esapi jar we will get 172 classes and a number of class load errors (due to missing jars references)

[![image](images/image_thumb_25255B1_25255D.png)](http://lh3.ggpht.com/-0CxWcThrLcs/UTCHqqX0_ZI/AAAAAAAAJ_w/0nXjmORdrFA/s1600-h/image%25255B5%25255D.png)

Let's refactor the code and create a **_addJarToSystemClassLoader_** method

[![image](images/image_thumb_25255B2_25255D.png)](http://lh4.ggpht.com/-aG0tJK4SQ9g/UTCHsc4Sp9I/AAAAAAAAKAA/IACWQvLNkxg/s1600-h/image%25255B8%25255D.png)

And load one of the dependencies (note the increased number of classes loaded (183)):

[![image](images/image_thumb_25255B3_25255D.png)](http://lh3.ggpht.com/-pFPhb5rrC1E/UTCHuEkeMAI/AAAAAAAAKAM/R_uQBaFhImw/s1600-h/image%25255B11%25255D.png)

And now if we load all jars in the libs folder (all 30 of them), we will get 197 classes and no load errors

[![image](images/image_thumb_25255B4_25255D.png)](http://lh3.ggpht.com/-w3wkLpJfQKI/UTCHvxFPyUI/AAAAAAAAKAg/o9ATxwXF2sA/s1600-h/image%25255B14%25255D.png)

here are the jars added to the classpath:

[![image](images/image_thumb_25255B5_25255D.png)](http://lh3.ggpht.com/-ea8jge_G9c4/UTCHxxUvydI/AAAAAAAAKAs/CBUPcqzfs78/s1600-h/image%25255B17%25255D.png)

here is the code (shown above) that loaded all esapi classes into the system class path:
    
    new API_Jni4Net().setUpBride();

    var classLoader = ClassLoader.getSystemClassLoader();

    Action<string> addJarToSystemClassLoader =   
        (pathToJar)=>{   
                        var addUrl = classLoader.getClass()  
                                                .getSuperclass()  
                                                .getDeclaredMethod("addURL", new Class[]{URL._class});  
                        addUrl.setAccessible(true);  
                        addUrl.invoke(classLoader, new java.lang.Object[]{ pathToJar.java_File().toURL() });   
                     };

    var esapiJar = @"E:\_Code_Tests\ESAPI\esapi-2.0.1.jar";  
    var esapiLibs = @"E:\_Code_Tests\ESAPI\libs";

    addJarToSystemClassLoader(esapiJar);  
    foreach(var jarFile in esapiLibs.files("*.jar"))  
        addJarToSystemClassLoader(jarFile);

    var classesInJar = esapiJar.java_Jar_Classes_Names();  
    return classLoader.loadClasses(classesInJar).size();

    //using net.sf.jni4net.jni;  
    //using java.lang;  
    //using java.net;  
    //O2File:API_Jni4Net.cs  
    //O2Ref:jni4net.n-0.8.6.0.dll  
  
Once these classes are loaded we can use the tool shown in [Using Jni4Net (Part 1) - To C# REPL a java process (ZAP Proxy)](http://blog.diniscruz.com/2012/11/using-jni4net-part-1-to-c-repl-java.html)  to browse them and view its source code:

[![image](images/image_thumb_25255B6_25255D.png)](http://lh6.ggpht.com/-v0gVDQy2nOc/UTCHz6J2q1I/AAAAAAAAKBA/Wo5mqoi7MP4/s1600-h/image%25255B20%25255D.png)

We can now create instances of ESAPI using reflection.

One problem to solve is the need to define where the ESAPI.properties file is:
    
    new API_Jni4Net().setUpBride();
    var classLoader = ClassLoader.getSystemClassLoader();
    
    var arrayList = "java.util.ArrayList".java_Class().newInstance();
    
    return "org.owasp.esapi.reference.DefaultSecurityConfiguration".java_Class().newInstance();
    
    var easpi = "org.owasp.esapi.ESAPI".java_Class();  
    return easpi.getMethod("encoder",null).invoke(null,null);  
    return easpi.newInstance().typeFullName();  
  
the code above will throw an error on line 439 of the **_DefaultSecurityConfiguration_** file

[![image](images/image_thumb_25255B7_25255D.png)](http://lh3.ggpht.com/-UJfJWhPePzk/UTCH14Z3B-I/AAAAAAAAKBM/9pYzkFf-KoQ/s1600-h/image%25255B23%25255D.png)

which is:

[![image](images/image_thumb_25255B8_25255D.png)](http://lh4.ggpht.com/-lLoxB3qGHO0/UTCH3kVha1I/AAAAAAAAKBc/4I-RRhc-3Mc/s1600-h/image%25255B26%25255D.png)

  
**Note: Using a separate class loader**

Here is a script that loads 172 classes from the esapi jar  

    
    var jni4Net = new API_Jni4Net();  
    jni4Net.setUpBride();
    
    var esapiJar = @"E:\_Code_Tests\ESAPI\esapi-2.0.1.jar";   
    var classLoader = (new URL[] {esapiJar.java_File().toURL() }).java_ClassLoader_forJars();
    
    return classLoader.loadClasses(esapiJar.java_Jar_Classes_Names()).size();
    
    //using net.sf.jni4net.jni;  
    //using java.lang;  
    //using java.net;  
    //O2File:API_Jni4Net.cs  
    //O2Ref:jni4net.n-0.8.6.0.dll  

This version will load 183 classes since we are also loading the servlet-api  

    
    var jni4Net = new API_Jni4Net();  
    jni4Net.setUpBride();  
    var servletApi = @"E:\_Code_Tests\ESAPI\libs\servlet-api-2.4.jar";  
    var esapiJar  =  @"E:\_Code_Tests\ESAPI\esapi-2.0.1.jar";   
    var classLoader = (new URL[] {esapiJar.java_File().toURL() , servletApi.java_File().toURL() }).java_ClassLoader_forJars();

    return classLoader.loadClasses(esapiJar.java_Jar_Classes_Names()).size();  
    //using net.sf.jni4net.jni;  
    //using java.lang;  
    //using java.net;  
    //O2File:API_Jni4Net.cs  
    //O2Ref:jni4net.n-0.8.6.0.dll  
