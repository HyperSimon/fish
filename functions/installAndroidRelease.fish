function installAndroidRelease
    cp env/release .env;
    cd android;
    ./gradlew --stop;
    ./gradlew installRelease;
    cd ..;
end








