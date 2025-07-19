# NoobMusic3
Music Player and Library written in NoobScript using the Noob App Platform

App can be found at https://noob.software/ for windows and mac.

This application demonstrates how an application can be made using the Noob App Platform which contains NoobScript and a basic layout engine for native view elements in Cocoa. NoobScript and the layout engine are both written in Objective-C. NoobScript has a similar syntax to PHP and has some aspects similar to JavaScript, for example you can define functions inline in code and send functions as variables (commonly referred to as Callback functions in JavaScript). NoobScript also passes arrays by reference instead of by value (like in JavaScript).

NoobScript also supports the async keyword prefixed in front of the function keyword (only for inline functions not class functions). Utilizing Multithreading this allows you to split execution into multiple ways and allow background processing without interrupting UI. NoobScript is also used in Server side code and has been proven with some amount of confidence to be thread safe for some functions. The general pattern you would use for async functions that breaks down processing would be to utilize the array-push function to collect results and then to use $object->once($result_callback) to call the final callback only once that would use the resulting array. Example code:

```
$res = [];

$last_callback = function() {
  $perform($res);
};

$caller = async function($parts) { //Will run asynchronously
  foreach($parts as $part) {
      //...perform some processing
      $res[] = $part['item']; //thread-safe function
  }
  if($res->length == $total_length) {  //depends on knowing the total length of the results;
    $object->once($last_callback);
  }
};

foreach($parts_split as $part_split) {
  $caller($part_split);
}
```

NoobScript also supports classes and inheritence using the "extends" keyword. $this is used to reference the class instance with respec to inherited functions but $self_instance references the class instance itself. The syntax is closely similar to PHP but "built-in" functions are kept in the $object global variable, and $files, and $object->strings->...

You can define your own "built-in" functions by defining a class in objective-c that inherits from PHPScriptObject and initializes blocks with the functions. Look at PHPincludedobjects.m for reference.

NoobScript allows you define the UI using HTML-like syntax and CSS-like layout definitions. You can animate using the animate function, where you can define layout changes as well as cubic-bezier easing function parameters.

This repo contains some amount of commented-out code which should obviously be removed, please bear with this if you inspect the code.

async functions usually require calling $object->dispose_parent($caller) when finalizing the function to dispose of the parent context of the callback.
