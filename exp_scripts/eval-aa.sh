#!/bin/bash
#### generic args
script_name=`basename "$0"`
id=${script_name%.*}
entry=${entry:-'src'}
seed=${seed:-2}
gpu=${gpu:-"auto"}
group=${group:-"eval-new"}
tag=${tag:-"none"}
log_tag=${log_tag:-"none"}

#### exp args
config=${config:-"attack"}
extra_configs=${extra_configs:-"none"}

#### ckpts
program_ckpt=${program_ckpt:-"none"}

prog_str=${prog_str:-"none"}
libname=${libname:-"default"} ## opt_library name
dsl=${dsl:-"conv"}


while [ $# -gt 0 ]; do
    if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
    fi
    shift
done

if [[ $extra_configs == "none" ]]; then
    extra_configs="task=AA;num_epochs_gs=1;hps={'lr':[0],'step':[100]}"
else
    extra_configs="task=AA;num_epochs_gs=1;hps={'lr':[0],'step':[100]};"$extra_configs
fi

echo $extra_configs

cd ../
python ${entry}/eval.py \
    --group $group --save $id --gpu $gpu --seed $seed \
    --config $config \
    --input_type "atom" --input_size 19 \
    --output_type "atom" --output_size 2 \
    --max_depth 10 \
    --extra_configs $extra_configs \
    --tag $tag \
    --log_tag $log_tag \
    --optimizer "AA" \
    --program_ckpt $program_ckpt \
    --libname $libname \
    --dsl $dsl \
    --prog_str $prog_str \