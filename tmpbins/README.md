had to change shell scripts to move env variables from tachyon to alluxio
the class paths have to stay tachyon unless source tree is changed. 

1) change tachyon->alluxio
2) change Tachyon->Alluxio
3) change TACHYON->ALLUXIO
4) when a class is called like tachyon.TFsShell; this stays the same. 
