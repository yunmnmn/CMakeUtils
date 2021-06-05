cmake_minimum_required(VERSION 3.13.1)

include_guard(GLOBAL) 

# Returns a postfix of a path depending on the platform
function(PlatformPath ret)
   if(WIN32)
      set(${ret} _Platform/Win PARENT_SCOPE)
   endif(WIN32)
   #Add more paths when it's supported
endfunction()

# Gather the Platform specific source files, and return them
function(PlatformSource source)
   #  All platform files are called PlatformFile.cmake
   set(platformCMakeFileName PlatformFile)

   # Get the platform path
   PlatformPath(platformPath)

   # TODO: hardcoded source
   set(platformRoot Source/${platformPath})
   get_filename_component(platformRoot ${platformRoot} ABSOLUTE)

   set(platformPath Source/${platformPath}/${platformCMakeFileName}.cmake)
   get_filename_component(platformPath ${platformPath} ABSOLUTE)

   # Find the platform path
   include(${platformPath})

   # Go through all sources referenced in the file, and validate if they exist
   foreach(file ${sources})
      get_filename_component(absolutePath ${platformRoot}/${file} ABSOLUTE)
      if(NOT EXISTS ${absolutePath})
         #TODO: proper error message
         message(FATAL_ERROR "Can't find file")
      endif()
      list(APPEND absoluteFilePaths ${absolutePath} )
   endforeach()

   # Set the file's sources into the Source variable
   set(${source} ${absoluteFilePaths} PARENT_SCOPE)
endfunction()

function(GenerateFolderStructure target)
   get_property(_targetSourceFiles TARGET ${target} PROPERTY SOURCES)
   source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}"
            FILES ${_targetSourceFiles})
endfunction()