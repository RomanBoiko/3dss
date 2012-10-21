{application, ads3dss,
    [
        {description, "ad3dss server application"},
        {id, "ads3dss"},
        {vsn, "1.0"},
        {registered, [simpletest_sup, simpletest]},
        {applications, [kernel, stdlib, sasl]},
        {modules, [application_manager, rest, simpletest_sup, simpletest]},
        {mod, {application_manager, []}}
    ]
}.