work(){
  cd $HDUSED/works/ && ls
  if [[ ! -z $1 ]]; then
    cd $1 && ls
  fi
}
alias prj="cd $HDUSED/projects/ && ls"
alias prjweb="cd $HDUSED/projects/web/ && ls"
alias wkweb="cd $HDUSED/works/web/ && ls"
alias mportoweb="cd /media/nizar/HD/Projects/Web/Porto"
alias hxrnk="cd $MYCODE/rust/hackerrank/ && vim"

