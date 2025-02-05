// RUN: tfg-transforms-opt -tfg-constant-folding %s | FileCheck %s

module  {
  tfg.graph #tf_type.version<producer = 1010, min_consumer = 0> {
    %Const, %ctl = Const name("c_mat") {dtype = f32, value = dense<2.000000e+00> : tensor<2x2xf32>} : () -> (tensor<2x2xf32>)
    %Const_0, %ctl_1 = Const name("c_vec") {dtype = f32, value = dense<3.000000e+00> : tensor<2xf32>} : () -> (tensor<2xf32>)
    // CHECK: %[[PLACEHOLDER:.*]], {{.*}} name("x_mat")
    %Placeholder, %ctl_2 = Placeholder name("x_mat") {dtype = f32, shape = #tf_type.shape<2x2>} : () -> (tensor<2x2xf32>)
    // CHECK: %[[PLACEHOLDER_3:.*]], {{.*}} name("x_vec")
    %Placeholder_3, %ctl_4 = Placeholder name("x_vec") {dtype = f32, shape = #tf_type.shape<2>} : () -> (tensor<2xf32>)
    // CHECK: %[[CHILD_1:.*]], {{.*}} Const {{.*}} name("child1/eval_0/const_folded")
    %BiasAdd, %ctl_5 = BiasAdd(%Const, %Placeholder_3) name("child1") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    // CHECK: Add(%[[CHILD_1]], %[[PLACEHOLDER_3]]) name("parent1")
    %Add, %ctl_6 = Add(%BiasAdd, %Const_0) name("parent1") {T = f32} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    // CHECK: %[[CHILD_1A:.*]], {{.*}} Const {{.*}} name("child1a/eval_0/const_folded")
    %BiasAdd_7, %ctl_8 = BiasAdd(%Const, %Placeholder_3) name("child1a") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    // CHECK: Add(%[[PLACEHOLDER_3]], %[[CHILD_1A]]) name("parent1a")
    %Add_9, %ctl_10 = Add(%Const_0, %BiasAdd_7) name("parent1a") {T = f32} : (tensor<2xf32>, tensor<2x2xf32>) -> (tensor<2x2xf32>)
    // CHECK: %[[CHILD_2:.*]], {{.*}} Const {{.*}} name("child2/eval_0/const_folded")
    %BiasAdd_11, %ctl_12 = BiasAdd(%Placeholder, %Const_0) name("child2") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    // CHECK: Add(%[[CHILD_2]], %[[PLACEHOLDER]]) name("parent2")
    %Add_13, %ctl_14 = Add(%BiasAdd_11, %Const) name("parent2") {T = f32} : (tensor<2x2xf32>, tensor<2x2xf32>) -> (tensor<2x2xf32>)
    // CHECK: %[[CHILD_2A:.*]], {{.*}} Const {{.*}} name("child2a/eval_0/const_folded")
    %BiasAdd_15, %ctl_16 = BiasAdd(%Placeholder, %Const_0) name("child2a") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    // CHECK: Add(%[[PLACEHOLDER]], %[[CHILD_2A]]) name("parent2a")
    %Add_17, %ctl_18 = Add(%Const, %BiasAdd_15) name("parent2a") {T = f32} : (tensor<2x2xf32>, tensor<2x2xf32>) -> (tensor<2x2xf32>)
    // CHECK: %[[CHILD_3:.*]], {{.*}} Const {{.*}} name("child3/eval_0/const_folded")
    %Add_19, %ctl_20 = Add(%Const, %Placeholder_3) name("child3") {T = f32} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    // CHECK: BiasAdd(%[[CHILD_3]], %[[PLACEHOLDER_3]]) name("parent3")
    %BiasAdd_21, %ctl_22 = BiasAdd(%Add_19, %Const_0) name("parent3") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    // CHECK: %[[CHILD_3A:.*]], {{.*}} Const {{.*}} name("child3a/eval_0/const_folded")
    %Add_23, %ctl_24 = Add(%Placeholder_3, %Const) name("child3a") {T = f32} : (tensor<2xf32>, tensor<2x2xf32>) -> (tensor<2x2xf32>)
    // CHECK: BiasAdd(%[[CHILD_3A]], %[[PLACEHOLDER_3]]) name("parent3a")
    %BiasAdd_25, %ctl_26 = BiasAdd(%Add_23, %Const_0) name("parent3a") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    // CHECK: %[[CHILD_4:.*]], {{.*}} Const {{.*}} name("child4/eval_0/const_folded")
    %BiasAdd_27, %ctl_28 = BiasAdd(%Const, %Placeholder_3) name("child4") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    // CHECK: BiasAdd(%[[CHILD_4]], %[[PLACEHOLDER_3]]) name("parent4")
    %BiasAdd_29, %ctl_30 = BiasAdd(%BiasAdd_27, %Const_0) name("parent4") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    %Add_31, %ctl_32 = Add(%Placeholder_3, %Placeholder_3) name("child5") {T = f32} : (tensor<2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    %BiasAdd_33, %ctl_34 = BiasAdd(%Const, %Add_31) name("parent5") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2x2xf32>) -> (tensor<2x2xf32>)
    %Add_35, %ctl_36 = Add(%Placeholder_3, %Const_0) name("child6") {T = f32} : (tensor<2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    %BiasAdd_37, %ctl_38 = BiasAdd(%Const, %Add_35) name("parent6") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2x2xf32>) -> (tensor<2x2xf32>)
    %Add_39, %ctl_40 = Add(%Placeholder, %Const_0) name("child7") {T = f32} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
    %BiasAdd_41, %ctl_42 = BiasAdd(%Add_39, %Const_0) name("parent7") {T = f32, data_format = "NHWC"} : (tensor<2x2xf32>, tensor<2xf32>) -> (tensor<2x2xf32>)
  }
}
