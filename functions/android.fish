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

                                case -a --assemble # install something
                                        switch $argv[(math $i+1)]
                                                case d debug  # install debug
                                                        echo '正在打包 Android deubg 版'
                                                        __assemble_android_debug # install 
                                                case r release # install release
                                                        echo '正在打包 Android release 版本'
                                                        __assemble_android_release
                                                case a alpha # install alpha
                                                        echo '正在打包 Android alpha 版本'
                                        end
				     
                        end
                end
        end
end



function __in_android_folder
         set -l parentPath (string split -r / (pwd))[-1]
         echo $parentPath
end

function __determin_location
         set -l parent (__in_android_folder)

         echo $parent

         switch $parent
              case android
                   echo "在Android文件夹中"
                   echo true
              case '*'
                   echo "不在Android文件夹中，尝试进入..."
                   cd android
         end
end


function __install_android_debug
         __determin_location;
        ./gradlew --stop;
        ./gradlew installDebug;
        cd ..;
end


function __install_android_release
        __determin_location
        ./gradlew --stop;
        ./gradlew installRelease;
        cd ..        
end

function __assemble_android_debug
         __determin_location;
        ./gradlew assembleDebug;
        cd ..;
end

function __assemble_android_release
         __determin_location;
        ./gradlew assembleRelease;
        cd ..;
        echo "release .apk 打包完成"
        
        set -l name (date "+%Y-%m-%d %H点%M分%S秒")
        echo "开始移除公司文件夹下已有的 .apk 文件"
        
        # 移除所有之前的apk
        rm ~/Dropbox/正佳/*.apk
        echo "移除完毕"
        
        echo "移动 release.apk 到 dropbox 文件夹下"
        cp android/app/build/outputs/apk/app-release.apk ~/Dropbox/正佳/"release $name.apk";
end





