import pandas as pd 
import numpy as np 

class Dataset:
	def __init__(self, filenames, drop_cols, label_column):
		self.files = filenames
		self.drop_cols = drop_cols
		self.label_column = label_column
		self.files_no_headers = ['data/training_data_means.csv', 'data/validation_data_means.csv', 'data/training_data_stdevs.csv', \
		'data/validation_data_stdevs.csv', 'data/training_data_entropy.csv', 'data/validation_data_entropy.csv']
		self.final_dataset, self.meta_data = self.load_datasets()
		self.data, self.labels = self.split_data_labels()

	def load_datasets(self):
		'''
		here we can load files into one datasets
		input: list of filenames that can be read as dataframes, drop_cols - a list of column names to drop
		output: DataFrame with merged columns per subject (either on subjectkey or subject), 
		dict of meta_data of each dataframe in case we want to separate them later
		'''
		final_dataset = pd.DataFrame()
		meta_data = {}
		for i,dataset in enumerate(self.files):
			sep = ',' if dataset.endswith('.csv') else '\t'
			if dataset in self.files_no_headers:
				df = pd.read_csv(dataset, sep=sep, header=None, prefix=dataset.split("_")[-1][0], index_col=0).fillna(0)
				df.index.name = 'subjectkey'
			else:
				df = pd.read_csv(dataset, sep=sep)
			meta_data[dataset] = {
				'columns': list(df.columns)
			}
			if i==0:
				final_dataset = df
			else:
				left_merge_value = 'subject' if 'subject' in final_dataset.columns else 'subjectkey'
				right_merge_value = 'subject' if 'subject' in df.columns else 'subjectkey'
				final_dataset = pd.merge(final_dataset, df, left_on=left_merge_value, right_on=right_merge_value)
		final_dataset =  final_dataset.drop([0], axis=0) #we are dropping this column with descriptions
		if self.drop_cols is not None: 
			final_dataset = self.drop_columns(final_dataset)
		meta_data['final_dataset'] = {
			'columns': list(final_dataset.columns)
		}
		return final_dataset, meta_data

	def split_data_labels(self):
		y = self.final_dataset[self.label_column].values.astype(float)
		X = self.final_dataset.drop([self.label_column, 'subject', 'subjectkey'], axis=1).values.astype(float)
		self.meta_data['final_dataset']['columns'] = [x for x in self.meta_data['final_dataset']['columns'] if x not in [self.label_column, 'subject', 'subjectkey']]
		return X, y


	def drop_columns(self, df):
		'''
		input: DataFrame 
		drops given columns
		output: DataFrame with less columns
		'''
		return df.drop(self.drop_cols, axis=1)

