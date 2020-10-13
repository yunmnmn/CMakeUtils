include_guard(GLOBAL) 

function(PlatformPath ret)
   if(WIN32)
      set(${ret} _Platform/Win PARENT_SCOPE)
   endif(WIN32)
   #Add more paths when it's supported
end_function()

function(PlatformSource source)
   set(PlatformCMakeFileName PlatformFiles.cmake)

   #Find the platform path
   PlatformPath(platformPath)
   set(platformPath ${platformPath}/${PlatformCMakeFileName})

   #Find the platform path
   include(${platformPath})

end_function()