App = {
    web3Provider: null,
    contracts: {},
    account: '0x0',
    hasVoted: false,
  
    init: function() {
      // Initialize Web3
      if (window.ethereum) {
        App.web3Provider = window.ethereum;
        window.web3 = new Web3(window.ethereum);
        // Request account access using eth_requestAccounts
        window.ethereum.request({ method: 'eth_requestAccounts' }).then(function(accounts) {
          App.account = accounts[0];
          // Call initContract after getting the account
          return App.initContract();
        }).catch(function(error) {
          // Handle error
          console.error("Error accessing account:", error);
        });
      } else {
        // Fallback to localhost if no web3 instance is detected
        App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
        window.web3 = new Web3(App.web3Provider);
        // Call initContract directly if no account access is needed
        App.initContract();
      }
    },
  
    initContract: function() {
      $.getJSON("Election2.json", function(election) {
        // Instantiate a new truffle contract from the artifact
        App.contracts.Election2 = TruffleContract(election);
        // Connect provider to interact with contract
        App.contracts.Election2.setProvider(App.web3Provider);
  
        return App.results();
      });
  
      $.getJSON("SkolFaithful.json", function(skolFaithful) {
        // Instantiate a new truffle contract from the artifact
        App.contracts.SkolFaithful = TruffleContract(skolFaithful);
        // Connect provider to interact with contract
        App.contracts.SkolFaithful.setProvider(App.web3Provider);
  
        return App.results();
      });
    },
  
    results: function() {
      $("#accountAddress2").html("Your Account: " + App.account);

      let amountToShow;

      switch(App.account){
        case '0xf220d553fbbc28b6f381cbb2be99d59de42d2f84'.toLowerCase():
            amountToShow = 1;
            break;
        case '0xFeb798ed0E1eC865Bf80703cA1E1Bb7a48DdEAfa'.toLowerCase():
            amountToShow = 6;
            break;
        case '0x48f84a00F895be17BD4Fa9e0731c7b39eAcd6FBe'.toLowerCase():
            amountToShow = 3;
            break;
        case '0xCF16fe704d4b01ecDD98A41af04B92008D2a32CC'.toLowerCase():
            amountToShow = 2;
            break;
        case '0x709E646fc789ec4b3D093C8871f66640E9c60616'.toLowerCase():
            amountToShow = 2;
            break;
        case '0x0022872cD7Dc3E7eA18242D815B85bF972df29b7'.toLowerCase():
            amountToShow = 1;
            break;
        case '0x29903d7E00703607844FCb5D1492B0AFC016E9bf'.toLowerCase():
            amountToShow = 1;
            break;
        case '0x8c7Fe6BdEa2e1a76C80dCB75BC0086f96dF550c2'.toLowerCase():
            amountToShow = 1;
            break;
        case '0x3f53E1a5c3c56bBd23d97890A28f9ce1c05ee563'.toLowerCase():
            amountToShow = 1;
            break;
        case '0x23cCEB31284c9b13361dfE36447Ece97e38Cc887'.toLowerCase():
            amountToShow = 1;
            break;
      }

      $("#reward").html("As a result of the voting, you were awarded: " + amountToShow + " MVC tokens");

      App.contracts.SkolFaithful.deployed().then(function(instance) {
        skolFaithfulInstance = instance;
        return skolFaithfulInstance.skolNation(App.account);
      }).then(function(candidate) {

        let newMVCAmount = Number(amountToShow) + Number(candidate[1]);
        $("#previous").html("Previous MVC in account: " + candidate[1] );
  
        $("#mvcAmount2").html("MVCs in your account: " + newMVCAmount);
      })
  
      var loader = $("#loader");
      var content = $("#content");
      var results = $("#results");
  
      loader.hide();
      content.hide();
      results.show();
      
    },

  };
  
  $(function() {
    $(window).load(function() {
      App.init();
    });
  });