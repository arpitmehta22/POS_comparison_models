#! /bin/bash
# Run in the same directroy as this script.

lang='hi'
lang_f='Hindi'
domain='dis'
adv_scale="0.05"
patience=30
exp_name="pos-${lang}-v1.2_blstm_blstm_crf_batch10_lr0.01_decay0.05_filter50_units150_adv_l2method_perturb-scale${adv_scale}"

exp_dir="./multi_lingual_exp/${lang}/${exp_name}"
mkdir -p $exp_dir

THEANO_FLAGS="mode=FAST_RUN,device=cuda1,floatX=float32,blas.ldflags='-lmkl -lguide -lpthread'" \
python ./bilstm_bilstm_crf.py --fine_tune --embedding polyglot --oov embedding --update momentum --adv $adv_scale \
  --batch_size 10 --num_units 150 --num_filters 50 --learning_rate 0.01 --decay_rate 0.05 --grad_clipping 5 --regular none --dropout \
  --train "../data/train_${domain}.conllu" \
  --dev "../data/test_${domain}.conllu" \
  --test "../data/test_${domain}.conllu" \
  --embedding_dict "../data/word_vec/polyglot-${lang}.pkl" \
  --output_prediction --patience $patience --exp_dir $exp_dir \
  |& tee -a $exp_dir/stdout_log.txt
