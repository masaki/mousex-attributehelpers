use Test::More;
eval "use Test::Pod 1.00";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
plan skip_all => "set TEST_POD to enable this test" unless $ENV{TEST_POD};
all_pod_files_ok();
