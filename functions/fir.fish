# tag 的 message 应该为从上一个tag处到现在的提交的所有message
# tag 的 message 应该移除 merge 的message

function fir
        # 制作一个 release 包
        android -a r; 

        # 上传至fir
        __upload_to_fir;
end



function __upload_to_fir

        # set -U bundle_id "your bundle id"
        # set -U api_token "your api token"

        # get auth
        set -l authResponse (curl -X "POST" "http://api.fir.im/apps" \
                                  -H "Content-Type: application/json" \
                                  -d "{\"type\":\"android\", \"bundle_id\":\"$bundle_id\", \"api_token\":\"$api_token\"}");

        # parse update token and key
        set -l qnmessage (echo $authResponse | jq '. | {key: .cert.binary.key, token: .cert.binary.token}');
                                  
        set -l key (string replace -a \" '' "key"=(echo $qnmessage | jq '. | .key'));
        
        set -l token "token="(echo $qnmessage | jq '. | .token');
        set -l tokenWithoutQuotes (string replace -a \" '' (echo $token))
        
        set -l version (__get_last_version)
        set -l message (__get_last_tag_message)

        # update to fir.im
        curl -F "$key"                                  \
             -F "$tokenWithoutQuotes"                              \
             -F "file=@/Users/sz1yyg/Desktop/release.apk"   \
             -F "x:name=红狸特惠"                             \
             -F "x:version=$version"                           \
             -F "x:build=1"                                 \
             -F "x:changelog=$message"                         \
        https://up.qbox.me;
end


function __get_last_version
        set -l versions (string split ' ' (git tag -l --sort=v:refname))
        set -l lastVersion (string sub -s 2 $versions[(count $versions)])
        echo $lastVersion
end

function __get_last_tag_message
        set -l versions (git tag -ln --sort=v:refname)
        set -l length (count $versions)
        set -l last $versions[$length]
        set -l message (string trim (string replace -r "v\d+.\d+.\d+" '' $last) )
        echo $message
end










