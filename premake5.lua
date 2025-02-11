workspace "IWindow"
    configurations {"Debug", "Release"}
    architecture "x86_64"

    configuration {"macosx"}
        linkoptions {"-framework Cocoa"}

    print ("Make sure to set the vulkan sdk path!")

    vulkanSdk = os.getenv("VULKAN_SDK");

    function defaultBuildCfg()
        filter "configurations:Debug"
            defines { "DEBUG" }
            symbols "On"
            runtime "Debug"
            optimize "Debug"

        filter "configurations:Release"
            defines { "NDEBUG" }
            symbols "Off"
            runtime "Release"
            optimize "Speed"
    end

    function defaultBuildLocation()
        targetdir ("bin/%{prj.name}/%{cfg.buildcfg}")
        objdir ("bin-int/%{prj.name}/%{cfg.buildcfg}")
    end

    startproject "TestWindow"

    project "TestWindow"
        location "test/TestWindow"
        kind "ConsoleApp"
        language "C++"
        cppdialect "C++17"

        platformLinks = nil
        platformFiles = nil

        if os.istarget("macosx") then
            platformFiles = {"src/IWindowCocoa.mm", "src/IWindowCocoaGamepad.cpp"}
            platformLinks = {}
        else
            platformFiles = {"src/IWindowWin32.cpp", "src/IWindowWin32Gamepad.cpp"}
            platformLinks = {"User32", "XInput"}
        end

        files {"%{prj.location}/Window.cpp", "%{prj.location}/stb.cpp", platformFiles}

        includedirs { "src" }

        links { "User32", "XInput" } 

        defaultBuildLocation()

        defaultBuildCfg()
        
    project "TestWindowGL"
        location "test/TestWindowGL"
        kind "ConsoleApp"
        language "C++"
        cppdialect "C++17"

        files {"%{prj.location}/WindowGL.cpp", "%{prj.location}/glad.cpp"}

        includedirs { "src", "%{prj.location}/deps/glad/include" }


        links {"IWindowWin32GL", "OpenGL32"}

        defaultBuildLocation()

        defaultBuildCfg()

    project "TestWindowVk"
        location "test/TestWindowVk"
        kind "ConsoleApp"
        language "C++"
        cppdialect "C++17"

        files {"%{prj.location}/WindowVk.cpp"}
        
        
        if package.config:sub(1,1) == "/" then -- Linux
            platformLinks = { "IWindowXlibVk", "X11", "Xcursor", "vulkan", "GLX" }
            includedirs { "src" }
        else
            libdirs { vulkanSdk .. "/Lib" }
            includedirs { vulkanSdk .. "/Include", "src" }
            platformLinks = { "IWindowWin32Vk", "User32", "vulkan-1" }
        end

        links { platformLinks }

        defaultBuildLocation()

        defaultBuildCfg()

    project "IWindowWin32GL"
        location "src"
        kind "StaticLib"
        language "C++"
        cppdialect "C++17"

        includedirs { "src" }

        files {"%{prj.location}/IWindowWin32.cpp", "%{prj.location}/IWindowWin32GL.cpp", "src/IWindowWin32Gamepad.cpp", "%{prj.location}/**.h", "%{prj.location}/**.hpp"}

        links {"User32", "OpenGL32", "XInput"}

        defaultBuildLocation()

        defaultBuildCfg()


    project "IWindowWin32Vk"
        location "src"
        kind "StaticLib"
        language "C++"
        cppdialect "C++17"

        files {"%{prj.location}/IWindowWin32.cpp", "%{prj.location}/IWindowWin32Vk.cpp", "src/IWindowWin32Gamepad.cpp", "%{prj.location}/**.h", "%{prj.location}/**.hpp"}

        includedirs { vulkanSdk .. "/Include", "src" }

        libdirs { vulkanSdk .. "/Lib" }
        links {"User32", "vulkan-1", "XInput"}

        defaultBuildLocation()

        defaultBuildCfg()

    project "IWindowWin32All"
        location "src"
        kind "StaticLib"
        language "C++"
        cppdialect "C++17"

        files {"%{prj.location}/IWindowWin32.cpp", "src/IWindowWin32Vk.cpp", "%{prj.location}/IWindowWin32GL.cpp", "src/IWindowWin32Gamepad.cpp", "%{prj.location}/**.h", "%{prj.location}/**.hpp"}

        includedirs { vulkanSdk .. "/Include", "src" }

        libdirs { vulkanSdk .. "/Lib" }
        links {"User32", "vulkan-1", "OpenGL32", "XInput"}

        defaultBuildLocation()

        defaultBuildCfg()

