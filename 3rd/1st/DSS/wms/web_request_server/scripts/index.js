var product_list = new Vue({
	el: '#app',
	data: {
		products: [
			// {Name:'Maçã', Reference:'18284721', Available:'122', Checked: false, Quantity: 0},
			// {Name:'Laranja', Reference:'84385433', Available:'410', Checked: false, Quantity: 0},
			// {Name:'Pêra', Reference:'23415004', Available:'92', Checked: false, Quantity: 0}
		]
	},
	methods: {
		fetchAllData:function(){
		   	axios
		   	.post('scripts/test.php',{ action: "fetchall" })
		   	//.post('./scripts/test.php', { action: "fetchall" })
			.then(function (response) {
				// console.log(response.data);
				// this.products = response.data;
				// console.log(this.products);
				pp = response.data;
				console.log(pp);
				Vue.set(product_list.products, 0, pp[0])
				for (i = 0; i < pp.length; i++) {
					Vue.set(product_list.products, i, pp[i]);
				} 

			})
			.catch(function (error) {
			 console.log(error);
			});
		},
		sendRequest() {
			request_prods = this.products.filter(function(item) {
			  return item.Checked == true;
			})
			var r = [];
			request_prods.forEach(function(x){
			  r.push(Object.assign({}, x, {Name: undefined,Available: undefined, Checked: undefined}));
			});
		  	console.log(JSON.stringify(r));


		  	axios.post('scripts/test.php',{ action: "request", data: r })
			.then(function (response) {
				console.log(response.data);
			})
			.catch(function (error) {
			 console.log(error);
			});


		},
		checkboxClicked:function(event,item){
			// console.log(event.target);
			if(event.target.checked) {
				item.Quantity = 1;
			} else {
				item.Quantity = 0;
			}
			
		},
		numberChanged(event,item){
			if(event.target.value <= 0) {
				item.Checked = false;
				item.Quantity = 0;
			}
		}
	},
	computed: {
		// a computed getter
		onlyChecked: function () {
		  // `this` points to the vm instance
		  return this.products.filter(function(item) {
			  return item.Checked == true;
			})
		},
	},
	created() {
		this.fetchAllData();
	}
});

// Vue.set(product_list.products, 0, product_list.fetchAllData()[0])

