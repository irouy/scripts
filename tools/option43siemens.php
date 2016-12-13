 <?php echo '<p>optie43 converter mash-up 20161212 </p>'; ?> 
 <?php echo '<p>form input example code</p>'; ?>
<form action="" method="post">
HEX: <input type="text" name="HEX_INPUT"><br>
<input type="submit">
</form>
<form action="" method="post">
ASCII: <input type="text" name="ASCII_INPUT"><br>
<input type="submit">
</form>
 <?php echo '<p>=========================</p>'; ?>
 <?php echo '<p>hex2bin function example code</p>'; ?>
<?php
$hex = hex2bin("766C616E");
var_dump($hex);
?>
<?php
if ( !function_exists( 'hex2bin' ) ) {
    function hex2bin( $str ) {
        $sbin = "";
        $len = strlen( $str );
        for ( $i = 0; $i < $len; $i += 2 ) {
            $sbin .= pack( "H*", substr( $str, $i, 2 ) );
        }

        return $sbin;
    }
}
?>
 <?php echo '<p>=========================</p>'; ?>
 <?php echo '<p>hex2str	str2hex function example code</p>'; ?>
<?php 
print hextostr("73646c703a2f2f3031302e3032302e3030312e3031313a3138343433")."\n"; 

print strtohex("sdlp://010.020.001.011:18443")."\n"; 

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
 <?php echo '<p>=========================</p>'; ?>
