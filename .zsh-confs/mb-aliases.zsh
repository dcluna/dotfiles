alias awslogin="saml2aws login --browser-autofill --skip-prompt --force"
function awsrole {
    export AWS_PROFILE=$(aws configure list-profiles | fzf)
}
