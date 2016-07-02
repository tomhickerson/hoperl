#!/usr/bin/perl

package Value;

my %op = ("add" => {
    "FEATURE,FEATURE" => 'add_features',
    "FEATURE,CONSTANT" => 'add_feature_con',
    "FEATURE,TUPLE" => 'add_feature_tuple',
    "TUPLE,TUPLE" => 'add_tuples',
    "TUPLE,CONSTANT" => undef,
    "CONSTANT,CONSTANT" => 'add_constants',
    NAME => "Addition"
          },
          "mul" => {
              "FEATURE,CONSTANT" => 'mul_feature_con',
              "TUPLE,CONSTANT" => 'mul_tuple_con',
              "CONSTANT,CONSTANT" => 'mul_constants',
              NAME => "Multiplication"
          },

    );
