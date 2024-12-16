cp2bk() {
	cp -r "$1" "$1.$(date +'%Y-%m-%d_%H:%M:%S_%Z').bak"
}

sudocp2bk() {
	sudo cp -r "$1" "$1.$(date +'%Y-%m-%d_%H:%M:%S_%Z').bak"
}

mv2bk() {
	mv "$1" "$1.$(date +'%Y-%m-%d_%H:%M:%S_%Z').bak"
}

sudomv2bk() {
	sudo mv "$1" "$1.$(date +'%Y-%m-%d_%H:%M:%S_%Z').bak"
}

bked() {
	cp "$1" "$1.$(date +'%Y-%m-%d_%H:%M:%S_%Z').bak"
	if [ "$?" -ne 0 ]; then
		echo "Cannot make backup copy"
		return
	fi
	nvim "$1"
}

sudobked() {
	sudo cp "$1" "$1.$(date +'%Y-%m-%d_%H:%M:%S_%Z').bak"
	if [ "$?" -ne 0 ]; then
		echo "Cannot make backup copy"
		return
	fi
	sudoedit "$1"
}

sesh-sessions() {
	{
		exec </dev/tty
		exec <&1
		local session
		session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
		[[ -z "$session" ]] && return
		sesh connect "$session"
	}
}
sesh-connect() {
	{
		exec </dev/tty
		exec <&1
		sesh connect "$(sesh list | fzf)"
	}
}

launch() {
	"$@" >/dev/null 2>&1 &
	disown
}
