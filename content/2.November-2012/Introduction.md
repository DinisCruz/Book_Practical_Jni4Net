##  Introduction

In November 2012 I found a way to make Java and .Net applications work together.

That is something that I've always wanted to be able to do, since it would allow the use of O2's REPL in Java application.

The the key technology innovations that were required to make this happen were:

* **1) Side-by-site JVM/CLR execution and programming (in same process)** - This is the ability provided by the amazing [http://jni4net.sourceforge.net/](http://jni4net.sourceforge.net/) FOSS project which creates bridges between Java and .Net(see this research paper for the main concept between .Net/Java bridges [http://views.cs.up.ac.za/vdata/Views-CCPE.pdf](http://views.cs.up.ac.za/vdata/Views-CCPE.pdf) )

* **2) Injection of Managed/Unmanaged controls into another process's controls/windows** - This the capability that added to to O2 which allows the easy injection of .NET dlls into other non managed process

Note that this is still a massive hack, and it would be great if there was a more official way to make this happen.
