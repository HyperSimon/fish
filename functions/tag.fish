function tag
        if __has_argv $argv
                if __has_commit
                        __add_version $argv
                end                        
        else
                echo "请输入参数"
        end
end

function __add_version
        set -l v_current (__get_last_version)
        set -l versions (string split . $v_current)
        
        set -g v_primary $versions[1]
        set -g v_function $versions[2]
        set -g v_bugfix $versions[3]

        if __is_bug_fix $argv  # add bug version
                set v_bugfix (math $v_bugfix + 1)
        else # add function version
                set v_function (math $v_function + 1)
        end
        
        set v_new $v_primary.$v_function.$v_bugfix
        set -l msgs (__commit_messages $v_current)
        echo "新版本为：" $v_new
        eval "git tag -a v$v_new -m $msgs"
end


function __get_last_version
        set tags (git tag -l)
        set -l lastIndex (math (count $tags))
        set -l last_tag $tags[$lastIndex]
        echo (string sub -s 2 $last_tag) # remove v
end


function __has_argv
        return (count $argv > /dev/null)
end

function __is_bug_fix
        switch $argv[1]
                case -f --funciton
                        return 1 # 1 == false
                case -b --bug    
                        return 0 # 0 == true
        end
end

function __has_commit
        set msg (__commit_messages (__get_last_version))
        set length (string length (string trim $msg))

        if math "$length == 0"
                return (__bool_false)
        else
                return (__bool_true)
        end
end

function __commit_messages
        set msg (eval "git log --pretty=format:'%s' v$argv...HEAD")
        echo $msg
end


function __bool_false
        return 1
end
function __bool_true
        return 0
end

