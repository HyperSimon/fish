function tag
        if count $argv > /dev/null

                # 设置版本号
                __ensure_version
                for i in (seq (count $argv))
                        
                        switch $argv[$i]
                                # 获取新的版本号
                                case -m --major
                                        set -g newVersion (__update_major)
                                case -f --feature
                                        set -g newVersion (__update_minor)
                                case -b --bug
                                        set -g newVersion (__update_patch)
                        end
                        
                        echo "新建版本:"$newVersion
                        set -l message (__make_message)
                        echo "新增修复:"
                        echo $message
                        
                        eval "git tag -a $newVersion -m \"$message\""
                end

        end
end



function __get_last_version
        set -l versions (string split ' ' (git tag -l --sort=v:refname))
        set -l lastVersion (string sub -s 2 $versions[(count $versions)])
        echo $lastVersion
end

function __get_subversion
        set -l lastVersion (__get_last_version)
        set -l versions (string split . $lastVersion)
        echo $versions[$argv]
end

function __ensure_version
        set -g major (__get_subversion 1)
        set -g minor (__get_subversion 2)       
        set -g patch (__get_subversion 3) 
end


# | major | minor | patch |
# major.minor.patch
# 大版本
function __update_major
        set -g major (math $major + 1)
        echo v$major.$minor.$patch
end

# 功能更新
function __update_minor
        set -g minor (math $minor + 1)
        echo v$major.$minor.$patch
end

# 补丁
function __update_patch
        set -g patch (math $patch + 1)
        echo v$major.$minor.$patch
end

function __make_message
        set -l tags (git tag -l --sort=v:refname)
        set -l lastTag $tags[(count $tags)]
        set -l message (git log --pretty=format:"%s" --no-merges $lastTag..)
        echo $message
end

