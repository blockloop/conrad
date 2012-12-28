// Make all external links open in a new tab/window
$.expr[':'].external = function(obj){
  return !obj.href.match(/^mailto\:/)
         && (obj.hostname != location.hostname)
         && !obj.href.match(/^javascript\:/)
         && !obj.href.match(/^$/)
};
$('a:external').attr('target', '_blank');

// 