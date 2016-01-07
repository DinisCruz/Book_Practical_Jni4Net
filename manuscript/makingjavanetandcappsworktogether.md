##  Making Java, .Net and C++ apps work together 

This past week I was in the 'zone' (coding 16h a day) and as you can see by the links below, I was able to (finally) find a way to **make Java, .Net and C++ apps work together. **

**I've 'only' been trying to do this for the past 5 years.**  
 
There are two key technological concepts at play here (which can work together or isolation)  

**1) Side-by-site JVM/CLR execution and programming (in same process)**
  
  * [Using Jni4Net (Part 1) - To C# REPL a java process (ZAP Proxy)](http://diniscruz.blogspot.co.uk/2012/11/using-jni4net-part-1-to-c-repl-java.html)
  * [Using Jni4Net (Part 2) - Controling OWASP ZAP remotely (via Java BeanShell REPL in .Net)](http://diniscruz.blogspot.co.uk/2012/11/using-jni4net-part-2-controling-owasp.html)
  * [Using Jni4Net (Part 3) - Writing and Invoking O2 Methods from Java and Eclipse](http://diniscruz.blogspot.co.uk/2012/11/using-jni4net-part-3-writing-and.html)
  * [Using Jni4Net (Part 4) - Integrating AppScan with TeamMentor (first PoC)](http://diniscruz.blogspot.co.uk/2012/11/jni4net-part-4-integrating-appscan-with.html)

  
**2) Injection of Managed/Unmanaged controls into another process's controls/windows**

  * [Injecting a .NET REPL into an Unmanaged/C++ application (Notepad)](http://diniscruz.blogspot.co.uk/2012/11/injecting-net-repl-into-unmanagedc.html)
  * [IBM AppScan Source's and AppScan Standard's TreeViews running side-by-site in the same GUI](http://diniscruz.blogspot.co.uk/2012/11/ibm-appscan-sources-and-appscan.html)

The Java bridge to .Net (and vice-versa) was created using the amazing: [http://jni4net.sourceforge.net/](http://jni4net.sourceforge.net/) FOSS project (see this research paper for the main concept between .Net/Java bridges [http://views.cs.up.ac.za/vdata/Views-CCPE.pdf](http://views.cs.up.ac.za/vdata/Views-CCPE.pdf) ) 
