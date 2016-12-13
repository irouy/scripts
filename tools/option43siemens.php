 <?php echo '<p>optie43 converter mash-up 20161212 </p>'; ?> 
 
<?php 

function hextostr($x) { 
  $s=''; 
  foreach(explode("\n",trim(chunk_split($x,2))) as $h) $s.=chr(hexdec($h)); 
  return($s); 
} 

function strtohex($x) { 
  $s=''; 
  foreach(str_split($x) as $c) $s.=sprintf("%02X",ord($c)); 
  return($s); 
} 
?>

<form action="" method="post">
	HEX: <input type="text" name="HEX_INPUT"><br>
	<input type="submit">
</form>

<form action="" method="post">
	ASCII: <input type="text" name="ASCII_INPUT"><br>
	<input type="submit">
</form>

<?php

//if (isset($_POST['HEX_INPUT'})) {
//	print hextostr($_POST['HEX_INPUT']);
//	}
//else {
//	print_form();
//}
	
print hextostr("73646c703a2f2f3031302e3032302e3030312e3031313a3138343433")."\n"; 

print strtohex("sdlp://010.020.001.011:18443")."\n"; 
?>
