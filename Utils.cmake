cmake_minimum_required(VERSION 3.13.1)

include_guard(GLOBAL) 

# Returns a postfix of a path depending on the platform
function(PlatformPath ret)
   if(WIN32)
      set(${ret} _Platform/Win PARENT_SCOPE)
   endif(WIN32)
   #Add more paths when it's supported
endfunction()

function(PlatformSource _source)
   # Get the platform path
   PlatformPath(_platformPath)

   # TODO: hardcoded source
   # GET all the platform specific source files from the "PlatformFile.cmake"
   set(_platformSource Source/${_platformPath})
   PlatformSourceInternal(${_platformSource} _sourceInternal)
   list(APPEND _sourceInternalAccum ${_sourceInternal})

   # GET all the platform specific header files from the "PlatformFile.cmake"
   set(_platformInclude Include/${_platformPath})
   PlatformSourceInternal(${_platformInclude} _sourceInternal)
   list(APPEND _sourceInternalAccum ${_sourceInternal})

   set(${_source} ${_sourceInternalAccum} PARENT_SCOPE)
endfunction()

# Gather the Platform specific source files, and return them
function(PlatformSourceInternal _path _sourceInternal)
   #  All platform files are called PlatformFile.cmake
   set(platformCMakeFileName PlatformFile)

   # TODO: hardcoded source
   get_filename_component(${_path} ${_path} ABSOLUTE)

   set(_platformPath ${_path}/${platformCMakeFileName}.cmake)
   get_filename_component(_platformPath ${_platformPath} ABSOLUTE)

   # Find the platform path
   include(${_platformPath})

   # Go through all sources referenced in the file, and validate if they exist
   # NOTE: _files is set from the platform specific .cmake file
   foreach(file ${_files})
      get_filename_component(_absolutePath ${_path}/${file} ABSOLUTE)
      if(NOT EXISTS ${_absolutePath})
         #TODO: proper error message
         message(FATAL_ERROR "Can't find file ${file}")
      endif()
      list(APPEND _absoluteFilePaths ${_absolutePath} )
   endforeach()

   # Set the file's sources into the Source variable
   set(${_sourceInternal} ${_absoluteFilePaths} PARENT_SCOPE)
endfunction()

function(GenerateFolderStructure target)
   get_property(_targetSourceFiles TARGET ${target} PROPERTY SOURCES)
   source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}"
            FILES ${_targetSourceFiles})
endfunction()

