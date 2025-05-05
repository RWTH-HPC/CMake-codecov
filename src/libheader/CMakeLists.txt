# This file is part of CMake-codecov.
#
# SPDX-FileCopyrightText: RWTH Aachen University, Federal Republic of Germany
# SPDX-FileContributor: Alexander Haase, alexander.haase@rwth-aachen.de
#
# SPDX-License-Identifier: BSD-3-Clause

add_library(header INTERFACE)
target_include_directories(header INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
