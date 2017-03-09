#!/bin/bash

# configure the mem_free complex_value for all execution hosts

qhost | awk 'NR>3 {
        print "qconf -mattr exechost complex_values mem_free=" $5,$1
}' | sh
