# edit-embeddings

An implementation of edit embeddings in the spirit of [Learning to represent edits](https://arxiv.org/abs/1810.1333).

## Implementation 

The goal is to implement the `Sequence Encoding of Edits` idea. From the paper this seems like an aligned diff is fed into a biLSTM to produce an edit representation; training these edit representations is done via an auto-encoding setup.
