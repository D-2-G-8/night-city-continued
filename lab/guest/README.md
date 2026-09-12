# lab/guest/

Scripts that run inside the lab VM: install the release and the change under test through
`ncc`, start the game with the harness, capture screenshots (ffmpeg), frame metrics
(PresentMon) and the redscript, CET and RED4ext logs.

The VM has no outbound network and no credentials. Anything here must work offline and must
not expect a token, an account or a shared drive.
