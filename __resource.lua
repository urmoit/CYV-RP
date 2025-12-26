resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'CYV RP Framework - A comprehensive role-playing framework for FiveM'

version '1.0.0'

author 'Kilo Code'

-- Client scripts
client_scripts {
    'client/*.lua'
}

-- Server scripts
server_scripts {
    'server/*.lua'
}

-- Shared scripts
shared_scripts {
    'shared/*.lua'
}

-- Configuration files
files {
    'config/*.lua'
}

-- Dependencies
dependencies {
    'oxmysql'
}

-- UI files (if needed)
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js'
}