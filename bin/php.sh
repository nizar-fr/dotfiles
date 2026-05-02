initphp(){
  mkdir $1;
  cd $1;
  touch index.php;
  "<?php echo \"Hello World\" " > index.php;
  vim .
}
