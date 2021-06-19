<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Raza;
use Illuminate\Http\Request; 
use Illuminate\Support\Facades\Gate;

class RazaController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        /* if(Gate::allows('razas-listar')){
            return Raza::all();
        }else{
            return null;
        }  */
        return Raza::all(); 
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $raza = new Raza();
        $raza->nombre = $request->nombre;   
        $raza->descripcion = $request->descripcion;
        $raza->especie_id = 2;
        $raza->save(); 
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Raza  $raza
     * @return \Illuminate\Http\Response
     */
    public function show(Raza $raza)
    {
        return $raza;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Raza  $raza
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Raza $raza)
    {
        $raza->nombre = $request->nombre;
        $raza->descripcion = $request->descripcion; 
        $raza->save();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Raza  $raza
     * @return \Illuminate\Http\Response
     */
    public function destroy(Raza $raza)
    {
        $raza->delete();
    }

    public function mascotas(Raza $raza){
        $raza->load('mascotas');            // cargar la funcion del model llamada mascotas //
        return $raza;
    }
}
