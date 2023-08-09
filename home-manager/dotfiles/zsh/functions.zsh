function joshuto_cwd() {
	ID="$$"
	mkdir -p /tmp/$USER
	OUTPUT_FILE="/tmp/$USER/joshuto-cwd-$ID"
	env joshuto --output-file "$OUTPUT_FILE" $@
	exit_code=$?

	case "$exit_code" in
    # regular exit
		0)
			;;
		# output contains current directory
		101)
			JOSHUTO_CWD=$(cat "$OUTPUT_FILE")
			cd "$JOSHUTO_CWD"
			;;
		# output selected files
		102)
			;;
		*)
			echo "Exit code: $exit_code"
			;;
	esac
}

function edit_config()
{
  CONFIG_FILE=$(rg --files --hidden --no-ignore-vcs "$XDG_CONFIG_HOME" --glob "!**/.git/*" | fzf)
  PREV_PWD=$(pwd)
  if [[ $? == 0 ]]; then
    cd $(dirname $CONFIG_FILE)
    $EDITOR $CONFIG_FILE
    cd $PREV_PWD
  fi
}

function prepend_sudo {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"; CURSOR+=5
  fi
}

function fzf_to_dir {
  PREV_PWD=$(pwd)
  cd $HOME
  DIR_PATH=$(rg --files --null --no-ignore-vcs --glob "!**/.git/*" | xargs -0 dirname | sort | uniq | fzf)

  if [[ $? == 0 ]]; then
    cd $DIR_PATH
  else
    cd $PREV_PWD
  fi
}
