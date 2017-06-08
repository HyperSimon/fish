function init

        set uname (__sss)

        if [ $uname = "Linux" ]
                # do nothing 
        else if count $argv > /dev/null
                for i in (seq (count $argv))
                        switch $argv[$i]
                                case 0 # install something
                                        sudo shutdown -r now
                        end
                end
        end
end


function __sss
        switch (uname)
                case Linux
                        echo Linux
                case Darwin
                        echo Mac
                case FreeBSD NetBSD DragonFly
                        echo FreeBSD
                case '*'
                        echo Hi, stranger!
        end
end

