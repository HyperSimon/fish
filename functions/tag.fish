function tag
        if count $argv > /dev/null
                
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
                        
                        echo $newVersion 
                        eval "git tag $newVersion"
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


# | major | minor | patch |
# 大版本
function __update_major
        set -l major (__get_subversion 1)
        set -l minor (__get_subversion 2)       
        set -l patch (__get_subversion 3) 

        set -l new_major (math $major + 1)
        echo v$new_major.$minor.$patch
end

# 功能更新
function __update_minor
        set -l major (__get_subversion 1)
        set -l minor (__get_subversion 2)       
        set -l patch (__get_subversion 3) 

        set -l new_minor (math $minor + 1)
        echo v$major.$new_minor.$patch
end

# 补丁
function __update_patch
        set -l major (__get_subversion 1)
        set -l minor (__get_subversion 2)       
        set -l patch (__get_subversion 3) 

        set -l new_patch (math $patch + 1)
        echo v$major.$minor.$new_patch
end
