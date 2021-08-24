# Snakefile for trans-eQTL analysis pipeline.
#Authors: Sophie Johnson and Brielin Brown
#Date: Thursday Jul 2, 2020

# Configuration
configfile: '/gpfs/commons/home/sjohnson/teqtl_pipeline/config.yaml'

# Convenience variables
fastq_dir = config['dir'] + '/geuvadis/FASTQ'
vcf_dir = config['dir'] + '/geuvadis/VCF'
sample_info = 'geuvadis_data_info.tsv'
abundance_dir = config['dir'] + '/transcript_abundance'
kallisto_idx = config['dir'] + '/resources/transcript_abundance/transcripts.idx'
transcript_fa = config['transcript_fa']
threads = config['threads'] 

ruleorder: kallisto_quant > make_dir

rule all:
    input:
        expand(abundance_dir + '/{sample}/abundance.tsv', sample = config['samples'].values())

rule make_dir:
    output:
         directory(abundance_dir + '/{sample}')
    shell:
        'mkdir {output}'

rule kallisto_make_index:
    input:
        transcript_fa
    output:
        kallisto_idx
    shell:
        'kallisto index -i {output} {input}'

rule kallisto_quant:
    input:
        idx = kallisto_idx,
        r1 = fastq_dir + '/{sample}_1.fastq.gz',
        r2 = fastq_dir + '/{sample}_2.fastq.gz'
    output:
        tsv = abundance_dir + '/{sample}/abundance.tsv'
    threads: threads
    shell:
        ' '.join(['kallisto quant -i','{input.idx}', '-o',
	abundance_dir + '/{wildcards.sample}',
	'-t', '{threads}', '{input.r1}', '{input.r2}'])
