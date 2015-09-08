#  Call this file with `source ./usage.sh`

#  Define usage function
usage(){
	cat <<-heredoc
		network_bytes: $network_bytes
		Don't forget to set the first two bytes in var.sh
		Usage: $0 [3rd Byte] [Range to scan] [Fast scan ? 0|1]
	heredoc

	exit 1
}
#  Call usage() if (-h | --help) option
[[ $1 ==  "-h" ]] || [[ $1 == "--help" ]] && usage
