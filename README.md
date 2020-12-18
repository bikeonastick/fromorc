
# fromorc

commandline tool that will get you simplified trail conditions from the morc
website.


# scratch notes

echo $'\360\237\221\216'
👎
echo $'\360\237\221\215'
👍
echo $'\360\237\244\236'
🤞


curl -s https://api.morcmtb.org/v1/trails | jq '.[]|{name: .trailName, status: .trailStatus, updated: .updatedAt}'


# Acknowledgement

Taking inspiration from [dtanner](https://gist.github.com/dtanner/54b10ef8932b026afec0398495b5b2b5).


