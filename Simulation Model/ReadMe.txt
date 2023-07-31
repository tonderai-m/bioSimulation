To run the simulation use netlogo version 6.1 or 6.2
Download and Install netlogo from:

https://ccl.northwestern.edu/netlogo/6.2.0/

********* In hierarchical structures the parent is on the top and the child is on the bottom

FS-ABS-F :::::: is the food safety agent based simulator for the facility used to simulate the facility operations 
this is a completely independent model it can be activated/used on its own, but can become a child model 


FS-ABS-S :::::: is the food safety agent based simulator for the Storage used to simulate the storage operations 
this is a dependent model which is also the parent in the sense that the operation starts at the facility and then the product is then moved to storage 
the child model in this case is hidden (running in the background no child GUI) to save computational resources  

Interactive-FS-ABS-S :::::: the same model as FS-ABS-S, but the child model is not hidden (two GUIs parent and child)