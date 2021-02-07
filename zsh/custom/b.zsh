##### BAZEL for NURO ##### 


# Basic Bazel shortcuts
alias bb="bazel build -c opt --config=cuda "
alias bba="bazel build -c opt --config=cuda --features asan "
alias br="bazel run -c opt --config=cuda "
alias bbt="bazel build --config tegra"
alias bt="time (b&&t)"


# Storage Builds
alias btf="bb base/file:tf_file_system"
alias ttf="./bazel-bin/base/file/tf_file_system"

alias bgcs="bazel build -c opt --config=cuda base/file:gcs_file_system_test"
alias tgcs="./bazel-bin/base/file/gcs_file_system_test"
alias btgcs="bgcs && USE_GCS_FILESYSTEM=true tgcs"

alias bs3="bb base/file:s3_file_system_test"
alias ts3="S3_STAT_CACHE_MAX_AGE=0 TF_CPP_MIN_LOG_LEVEL=6 AWS_REGION=us-west-1 ./bazel-bin/base/file/s3_file_system_test"
alias bts3="bs3 && ts3"

alias bnfs="bb base/file:nfs_client_test"
alias tnfs="./bazel-bin/base/file/nfs_client_test"


alias blocator="bb nufs/client:nufs_client_test"
alias tlocator='./bazel-bin/nufs/client/nufs_client_test'
alias btlocator='blocator && tlocator'

alias bnufs="bb nufs/client:nufs_file_system_test"
alias tnufs='./bazel-bin/nufs/client/nufs_file_system_test'
alias btnufs='bnufs && tnufs'


# Autonomy Builds
alias brr="bazel build -c opt --config=cuda onboard/comms:registry_runner"
alias rrr="bazel-bin/onboard/comms/registry_runner"

alias bpb="bazel build -c opt --config=cuda playback/playback_core:playback"
alias rpb="bazel-bin/playback/playback_core/playback --sensor --blob "

alias bnv="bb onboard/nuro_viewer:nuro_viewer_offboard"
alias rnv="bazel-bin/onboard/nuro_viewer/nuro_viewer_offboard --playback"

alias bsm="bazel build -c opt --config=cuda simulation/simulator:simulator_main"
alias bbs="bb servers/borg:batch_simulation"
alias bhub="bb simulation/pacman/hub:agent_hub_server_main"


# ML Builds
alias bddag="bb learning/airflow/tools:delete_dag"
alias rddag="bazel-bin/learning/airflow/tools/delete_dag"
alias rddagbroken="bazel-bin/learning/airflow/tools/delete_dag --remove_file_only "
alias bml="bb learning/nuroflow/utils/k8s_run"

alias rmhtctrainocal="rm -rf /tmp/local-mh-train/ && ./bazel-bin/learning/deepnets/tensorflow/trajectory/trainer --model=mh_pvc --model_id=prod  --data_uri=/mnt/mlstorage/mldata/predictor/data/airflow-auto-run/tf_record_train_eval_20191218011851  --model_dir=/tmp/local-mh-train"
alias bmhtctrain="bb learning/deepnets/tensorflow/trajectory:trainer"



# Map Builder Builds
alias bmb="bazel build -c opt --config=cuda mapping/context_map_builder:map_builder"
alias rmb="./bazel-bin/mapping/context_map_builder/map_builder"
alias rmbp="./bazel-bin/mapping/context_map_builder/map_builder --use_plasticbox"



##### Nuro SIMTESTS ##### 

func simtest-jobname-category() {
  bazel-bin/servers/borg/batch_simulation --job_name=$1  --email=ziliang --commit=`githead` --cloud  --categories=$2
}
func simtest4-jobname-category() {
  bazel-bin/servers/borg/batch_simulation --job_name=$1  --extra_job_dict 'resource_multiplier:4' --email=ziliang --commit=`githead` --cloud  --categories=$2
}
func simtest-nufs-jobname-category() {
  #bazel-bin/servers/borg/batch_simulation --job_name=$1  --extra_job_dict 'use_nufs:true' --email=ziliang --commit=`githead` --cloud  --categories=$2
  bazel-bin/servers/borg/batch_simulation --job_name=$1  --extra_job_dict 'nufs_ttl:48' --email=ziliang --commit=`githead` --cloud  --categories=$2
}
func simtest4-nufs-jobname-category() {
  bazel-bin/servers/borg/batch_simulation --job_name=$1  --extra_job_dict 'nufs_ttl:48,resource_multiplier:4' --email=ziliang --commit=`githead` --cloud  --categories=$2
}
func simtest2-nufs-jobname-category() {
  bazel-bin/servers/borg/batch_simulation --job_name=$1  --extra_job_dict 'nufs_ttl:48,resource_multiplier:2' --email=ziliang --commit=`githead` --cloud  --categories=$2
}
func simtest-n-delay-jobname-category() {
  for i in $(seq 1 $1);
  do
    bazel-bin/servers/borg/batch_simulation --job_name=$3-$i  --email=ziliang --commit=`githead` --cloud  --categories=$4
    sleep $2
  done
}
func simtest-n-jobname-category() {
  simtest-n-delay-jobname-category $1 30 $2 $3
}
func simtestgcs() {
  bazel-bin/servers/borg/batch_simulation --extra_job_dict=use_gcs_api:true --job_name=gcs-$1  --email=ziliang  --nouse_cache --commit=`githead` --cloud  --categories=$2
}
func simtestfuse() {
  bazel-bin/servers/borg/batch_simulation --extra_job_dict=use_gcsfuse:true --job_name=gcsfuse-$1  --email=ziiang  --nouse_cache --commit=`githead` --cloud  --categories=$2
}
func simtestlocal() {
  bazel-bin/servers/borg/batch_simulation --job_name=$1  --email=v  --commit=`githead` --local --categories=$2
}
#func simtestlocalgcs() {
#  bazel-bin/servers/borg/batch_simulation --extra_job_dict=use_gcs_api:true --job_name=gcs-$1  --email=v  --nouse_cache --commit=$2 --local  --categories=$3
#}
func simtestdefault() {
  simtest $1 ''
}


#alias f="precommit/format.py && tools/lint/run_lint --fix"
alias f='tools/lint/run_lint --fix'
alias fexp="yapf -r --in-place experimental/zpeng"

alias ctidy='tools/clang_tidy/clang_tidy.py'




# deprecated
# alias remove_tx2="ssh nvidia@$TX2_IP rm tx2_camera_capturing"
# alias upload_tx2="scp bazel-bin/experimental/izhou/tx2/tx2_camera_capturing nvidia@$TX2_IP:"
# alias btx2="bbt experimental/izhou/tx2/tx2_camera_capturing && remove_tx2 ; upload_tx2"

# alias bng="bb onboard/comms/graph:node_graph"
# alias rng="bazel-bin/onboard/comms/graph/node_graph --norun_active_roi --test_camera --planner_ignore_known_context_map_inconsistencies --norun_traffic_signals --norun_voxel --norun_rgbd --use_ngm_flags --norun_track_classifier --norun_fisheye --norun_camera_stitching"




# alias ba="bb onboard/audio:audio_loop"
# alias ra="./bazel-bin/onboard/audio/audio_loop --params_profile onboard/audio/audio_loop_test.pbtxt"
# alias bra="ba && ra"
# alias rls-check="./bazel-bin/simulation/framework/utils/celery_check_result"
