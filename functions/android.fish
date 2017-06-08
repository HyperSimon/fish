function android
        # if set -e argv[1]
        #         echo 'e arguemnt'
        # end

        # if set -i argv[2]
        #         echo 'i arguemnt'
        # end

        if count $argv > /dev/null
                for i in (seq (count $argv))
                        switch $argv[$i]
                                case -i --install --in # install something
                                        switch $argv[(math $i+1)]
                                                case d debug  # install debug
                                                        echo '正在安装 Android deubg 版'
                                                        __install_android_debug # install 
                                                case r release # install release
                                                        echo 'install release'
                                                        __install_android_release
                                                case a alpha # install alpha
                                                        echo 'install alpha'
                                        end
                                        
                                case '-e'
                                        echo 'e argument'
                        end
                end
                
        end
end




function __install_android_debug
        ./gradlew --stop;
        ./gradlew installDebug;
end


function __install_android_release
        ./gradlew --stop;
        ./gradlew installRelease;
end







