used_plugins = ["-DDISABLE_PLUGINS_BY_DEFAULT=TRUE",
                "-DPLUGIN_PLUGIN_ASTAR_ENABLED=TRUE",
                "-DPLUGIN_PLUGIN_EAGER_GREEDY_ENABLED=TRUE",
                "-DPLUGIN_PLANOPT_HEURISTICS_ENABLED=TRUE",
                "-DPLUGIN_LANDMARK_CUT_HEURISTIC_ENABLED=TRUE"
                ]
release = ["-DCMAKE_BUILD_TYPE=Release"] + used_plugins
debug = ["-DCMAKE_BUILD_TYPE=Debug"] + used_plugins
release_no_lp = ["-DCMAKE_BUILD_TYPE=Release", "-DUSE_LP=NO"]
# USE_GLIBCXX_DEBUG is not compatible with USE_LP (see issue983).
glibcxx_debug = ["-DCMAKE_BUILD_TYPE=Debug", "-DUSE_LP=NO", "-DUSE_GLIBCXX_DEBUG=YES"]
minimal = ["-DCMAKE_BUILD_TYPE=Release", "-DDISABLE_PLUGINS_BY_DEFAULT=YES"]

DEFAULT = "release"
DEBUG = "debug"
