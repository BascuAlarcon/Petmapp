<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Cuidado;
use Illuminate\Http\Request;

class CuidadoController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return Cuidado::all();  
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $cuidado = new Cuidado();
         
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Cuidado  $cuidado
     * @return \Illuminate\Http\Response
     */
    public function show(Cuidado $cuidado)
    {
        return $cuidado;
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Cuidado  $cuidado
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Cuidado $cuidado)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Cuidado  $cuidado
     * @return \Illuminate\Http\Response
     */
    public function destroy(Cuidado $cuidado)
    {
        $cuidado->delete();
    }
}
