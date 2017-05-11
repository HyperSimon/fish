function installAndroidDebug
    cp env/default .env;
    cd android;
    ./gradlew --stop;
    ./gradlew installDebug;
    cd ..;
end
