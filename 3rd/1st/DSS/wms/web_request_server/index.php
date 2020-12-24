<!DOCTYPE html>
<html lang="en" class="h-75">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>WMS - Request Server</title>
        <!-- Bootstrap core CSS -->
        <link href="bootstrap/css/bootstrap.css" rel="stylesheet">
        <!-- Custom styles for this template -->
        <link href="style.css" rel="stylesheet">
        <script>/* Pinegrow Interactions, do not remove */ (function(){try{if(!document.documentElement.hasAttribute('data-pg-ia-disabled')) { window.pgia_small_mq=typeof pgia_small_mq=='string'?pgia_small_mq:'(max-width:767px)';window.pgia_large_mq=typeof pgia_large_mq=='string'?pgia_large_mq:'(min-width:768px)';var style = document.createElement('style');var pgcss='html:not(.pg-ia-no-preview) [data-pg-ia-hide=""] {opacity:0;visibility:hidden;}html:not(.pg-ia-no-preview) [data-pg-ia-show=""] {opacity:1;visibility:visible;display:block;}';if(document.documentElement.hasAttribute('data-pg-id') && document.documentElement.hasAttribute('data-pg-mobile')) {pgia_small_mq='(min-width:0)';pgia_large_mq='(min-width:99999px)'} pgcss+='@media ' + pgia_small_mq + '{ html:not(.pg-ia-no-preview) [data-pg-ia-hide="mobile"] {opacity:0;visibility:hidden;}html:not(.pg-ia-no-preview) [data-pg-ia-show="mobile"] {opacity:1;visibility:visible;display:block;}}';pgcss+='@media ' + pgia_large_mq + '{html:not(.pg-ia-no-preview) [data-pg-ia-hide="desktop"] {opacity:0;visibility:hidden;}html:not(.pg-ia-no-preview) [data-pg-ia-show="desktop"] {opacity:1;visibility:visible;display:block;}}';style.innerHTML=pgcss;document.querySelector('head').appendChild(style);}}catch(e){console&&console.log(e);}})()</script>
        <!-- Vue -->
        <script src="https://cdn.jsdelivr.net/npm/vue@2.6.12/dist/vue.js"></script>
        <!-- axios -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.21.0/axios.js"></script>

    </head>
    <body class="h-100">
        <!-- Bootstrap core JavaScript
    ================================================== -->
        <!-- Placed at the end of the document so the pages load faster -->
        <div id="app" class="container h-100 mw-100 user-select-auto">
            <div class="position-static row w-auto" style="background-color: #1F2940" >
                <img src="images/Logo.png" height="50" width="50" class="mb-3 ml-3 mr-0 mt-3">
                <h1 class="m-3 text-white">WMS - Request Server</h1>
            </div>
            <div class="align-items-stretch flex-row h-100 row">
                <div class="border col-md-2 pt-3">
                    <h2>Heading 2</h2> 
                    <p>Paragraph</p> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus pulvinar faucibus neque, nec rhoncus nunc ultrices sit amet. Curabitur ac sagittis neque, vel egestas est. Aenean elementum, erat at aliquet hendrerit, elit nisl posuere tortor, id suscipit diam dui sed nisi. Morbi sollicitudin massa vel tortor consequat, eget semper nisl fringilla. Maecenas at hendrerit odio. Sed in mi eu quam suscipit bibendum quis at orci. Pellentesque fermentum nisl purus, et iaculis lectus pharetra sit amet.
                </div>
                <div class="border col-md mt-0 pt-3">
                    <div class="input-group mb-3 mw-100">
                        <input type="text" class="form-control" aria-label="Recipient's username" aria-describedby="basic-addon2" placeholder="Product Name">
                        <div class="input-group-append">
                            <button class="btn btn-outline-secondary" type="button">Search
                                <br>
                            </button>
                        </div>
                    </div>
                    <table id="product_table" class="border table table-bordered table-sm table-striped"> 
                        <thead style="background-color: #1F2940; color: #ffffff;"> 
                            <tr> 
                                <th style="width: 5%">#</th> 
                                <th style="width: 22.5%">Product<br></th> 
                                <th style="width: 15%">Reference</th> 
                                <th style="width: 10%">Available</th>
                                <th style="width: 10%">Quantity</th>
                            </tr>                             
                        </thead>                         
                        <tbody> 
                            <tr
                              v-for="(item, index) in products"
                              v-bind:key="item.Reference"
                              v-bind:class="{ 'table-success': item.Checked}"
                            >
                                <th scope="row">{{index + 1}}</th> 
                                <td>{{item.Name}}</td>
                                <td>{{item.Reference}}</td>
                                <td>{{item.Available}}</td>
                                <td>
                                    <div>
                                        <input v-model="item.Checked" v-on:click="checkboxClicked($event,item)" type="checkbox">
                                        <input type="number"  v-model="item.Quantity" :max="item.Available" v-bind:disabled="!item.Checked" @change="numberChanged($event,item)" class="h-25 small w-50" placeholder="0">
                                    </div>
                                </td>        
                            </tr>

                        </tbody>                         
                    </table>
                </div>
                <div class="bg-light border col-md-3 pt-3">
                    <h3>Request</h3> 
                    <p>Current list of requested items</p>
                    <div class="row text-center">
                        <table class="table table-sm"> 
                            <thead> 
                                <tr> 
                                    <th>#</th> 
                                    <th>Product</th> 
                                    <th>Reference</th> 
                                    <th>Quantity</th> 
                                </tr>                                 
                            </thead>                             
                            <tbody> 
                                <tr
                                  v-for="(item, index) in onlyChecked"
                                  v-bind:key="item.Reference"
                                >
                                    <th scope="row">{{index + 1}}</th> 
                                    <td>{{item.Name}}</td>
                                    <td>{{item.Reference}}</td>
                                    <td>{{item.Quantity}}</td>   
                                </tr>

                            </tbody>                             
                        </table>
                    </div>
                    <div class="row">
                        <div class="w-100 text-center">
                            <button v-show="onlyChecked.length > 0" onclick="this.blur();" @click="sendRequest()" type="button" class="btn btn-outline-dark">Confirm</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/popper.js"></script>
        <script src="bootstrap/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="pgia/lib/pgia.js"></script>
        <script src="scripts/index.js"></script>

    </body>
</html>
