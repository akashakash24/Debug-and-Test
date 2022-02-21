#include <linux/module.h> 
#include <linux/kernel.h> 
#include <linux/init.h> 
MODULE_LICENSE("GPL"); 
MODULE_VERSION("4.15.0-133-generic"); 
static int __init start(void)
{  
  printk(KERN_INFO "Loading module....");  
  printk(KERN_INFO "Hello World....");  
  return 0; 
} 

static void __exit end(void)
{  
  printk(KERN_INFO "Bye World...."); 
} 
module_init(start); 
module_exit(end); 
