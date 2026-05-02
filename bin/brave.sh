function brv() {
    case "$1" in
        nzr)  profile="Profile 1" ;;
        msc)  profile="Profile 2" ;;
        tech) profile="Profile 3" ;;
        game) profile="Profile 4" ;;
        dsgn) profile="Profile 5" ;;
        sccr) profile="Profile 6" ;;
        tv)   profile="Profile 7" ;;
        bkp)  profile="Profile 8" ;;
        rzg)  profile="Profile 9" ;;
        apa)  profile="Profile 10" ;;
        old)  profile="Profile 11" ;;
        law)  profile="Profile 12" ;;
        pol)  profile="Profile 13" ;;
        my)   profile="Profile 14" ;;
        hxk)  profile="Profile 15" ;;
        rsch) profile="Profile 16" ;;
        hrdw) profile="Profile 17" ;;
        shit) profile="Profile 18" ;;
        eco)  profile="Profile 19" ;;
        bzz)  profile="Profile 20" ;;
        cltr) profile="Profile 21" ;;
        sci)  profile="Profile 22" ;;
        hlt)  profile="Profile 23" ;;
        psy)  profile="Profile 24" ;;
        self) profile="Profile 25" ;;
        aaaa) profile="Profile 26" ;;
        data) profile="Profile 27" ;;
	*)
            echo "Profile key '$1' not recognized."
            return 1
            ;;
    esac
    /usr/bin/brave-browser-stable %U --profile-directory="$profile" && exit
}
